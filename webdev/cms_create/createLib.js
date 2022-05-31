/* eslint-disable arrow-parens */
import { PendingXHR } from 'pending-xhr-puppeteer';
import * as utils from './utils.js';
import msg from './msg.js';

const TIME_SHORT = 500;
const TIME_MED = 1200;
const TIME_LONG = 1700;

/**
 * Login in to the the CMS.
 * @param {Object} config - Config object.
 * @param {Object} config.page - Page handle.
 * @param {String} config.location - Page url to log into.
 * @param {String} config.user - Username.
 * @param {String} config.password - Password.
 */
export async function login({ page, location, user, password }) {
    const inputs = {
        email: '.cmsLoginForm input[name="email"]',
        password: '.cmsLoginForm input[name="password"]',
    };

    const buttons = {
        login: '.cmsLoginForm .cmsButton',
    };

    try {
        await page.goto(location);
        await page.type(inputs.email, user);
        await page.type(inputs.password, password);
        await page.click(buttons.login);
        await page.waitForNavigation({ waitUntil: 'networkidle2' });
    } catch (error) {
        console.error('Unable to loging: ${error}');
        throw (error);
    }
}

/**
 * Create a new page in the CMS, starting with
 * create new button click
 * @param {Object} config - Config object.
 * @param {Object} config.page - Page handle.
 * @param {String} config.title - Title of the page.
 * @param {String} config.sectionPage - The location of where to add the page.
 */
export async function createNewPage(
    { page, title, layoutName }) {

    const buttons = {
        createNew: `.listBar [data-name="core_create"]`,
        saveChanges: '.form-actions button.button_core_submit',
    };

    msg('Creating new page: ');
    const pendingXHR = new PendingXHR(page);
    await page.click(buttons.createNew);
    await pendingXHR.waitForAllXhrFinished();

    msg('Typing in the input field: ', title);
    await page.waitForTimeout(TIME_LONG);
    await page.type('input[name="title"]', title, { delay: 40 });

    msg('Clicking on the button: ');
    await page.click(buttons.saveChanges);
    await page.waitForTimeout(TIME_SHORT);

    await utils.attempt(async () => {
        await page.waitForSelector('.plugins_nav_pagePanels .panes',
            { visible: true, timeout: 1000 });
    }, 2);

    if (layoutName) {
        await selectLayout({ page, title: layoutName });
        await savePage({ page });
    } else {
        await selectPage(page);
        await savePage({ page });
    }
}

/**
 * Use mutation observer to find item
 * @param {Object} config - Config object.
 * @param {String} config.selector - Elem to find.
 * @param {String} config.observe - Elem to observe.
 * @param {Object} config.options - Options object, main.
 * @return {Object} returns a promise if found.
 */
async function useMutation({ selector, observe, options = {} }) {
    return new Promise((resolve, reject) => {
        const observeNode = document.querySelector(observe);
        const element = document.querySelector(selector);
        if (element) {
            resolve(element);
            return;
        }
        const mutObserver = new MutationObserver((mutations) => {
            for (const mutation of mutations) {
                const nodes = Array.from(mutation.addedNodes);
                for (const node of nodes) {
                    if (node.matches && node.matches(selector)) {
                        mutObserver.disconnect();
                        resolve(node);
                        return;
                    }
                }
            }
        });
        mutObserver.observe(observeNode,
            { childList: true, subtree: true });
        if (options.timeout) {
            setTimeout(() => {
                mutObserver.disconnect();
                if (options.optional) {
                    resolve(null);
                } else {
                    reject(new Error(`Timeout exceeded while
                        waiting for selector ("${selector}").`));
                }
            }, options.timeout);
        }
    });
}

/**
 * Recursively follow a path and create pages
 * if they don't exist
 * @param {Object} config - Config object.
 * @param {Object} config.page - Page handle.
 * @param {String} config.path - Path string.
 * @param {String} config.layout - Layout to use for each page.
 * @param {String} config.sectionPage - This is the page URL
 */
export async function followPath({ page, path, layoutName }) {
    if (!path) return;

    path = path.replace(/^\//, "");
    const pathArr = String(path).split('/');
    const firstElement = pathArr[0];
    pathArr.shift();

    await page.waitForSelector('.listContainer', { visible: true });
    const exist = await pageExists({ page, title: firstElement });

    msg('\tPage exists?...', exist);

    if (exist) {
        const pendingXHR = new PendingXHR(page);
        await clickPageFromList({ page, name: firstElement });
        await pendingXHR.waitForAllXhrFinished();

        await followPath({ page, path: pathArr.join('/'), layoutName });
    } else {
        msg('\tCreating new page: ', firstElement);
        await createNewPage({
            page, title: firstElement,
            layoutName
        });

        await page.waitForSelector('.listContainer', { visible: true });

        const pendingXHR = new PendingXHR(page);
        await clickPageFromList({ page, name: firstElement });
        await pendingXHR.waitForAllXhrFinished();

        await followPath({ page, path: pathArr.join('/'), layoutName });
    }
}

/**
 * Check if a page exists
 * @param {Object} config - Config object.
 * @param {Object} config.page - Page handle.
 * @param {string} config.title - Title of the page to check.
 */
export async function pageExists({ page, title }) {
    let status = false;
    await page.waitForTimeout(TIME_MED);
    try {
        status = await page.evaluate(title => {
            // TODO: make this use the getRowFromList function instead
            const sel = '[data-type="Page"] [data-name="folder"] .cellWrapper';
            const allPages = document.querySelectorAll(sel);
            const pageTitle = [];
            allPages.forEach(page => {
                const anchor = page.querySelector('a');
                if (anchor?.innerHTML === title || page?.innerHTML === title) {
                    pageTitle.push(page.innerHTML);
                }
            });
            return pageTitle;
        }, title);
    } catch (error) {
        console.error('error');
        throw (error);
    }
    msg("pageExist... status ", status);
    return status.length;
}

/**
 * create a new layout in the cms, with optional saved panels
 * @param {object} config - config object.
 * @param {object} config.page - page handle.
 * @param {string} config.name - name of layout.
 * @param {boolean} config.createsavedpanels - create a saved panel?
 * @param {string} config.layoutpage - url of layout page.
 */
export async function createNewLayout(
    { page, name, createSavedPanels = true, layoutPage } = {}) {
    const input = {
        name: 'input[name="name"]',
    };
    const buttons = {
        createNew: `.listBar [data-name="core_create"]`,
        saveChanges: '.form-actions button.button_core_submit',
    };
    // TODO: first element don't work here, need to fix
    //const exist = await pageExists({ page, title: firstElement });
    //msg('\tCheck if layout exists...', exist);
    //if(exist) return;

    await page.goto(layoutPage);
    await page.click(buttons.createNew);
    //await page.waitForNavigation({ waitUntil: 'networkidle2' });
    await page.waitForTimeout(TIME_MED);
    await page.type(input.name, name);
    await page.click(buttons.saveChanges);

    await utils.attempt(async () => {
        await page.waitForSelector('.plugins_nav_pagePanels .panes',
            { visible: true, timeout: 2000 });
    }, 2);

    await selectPage(page);

    await page.waitForTimeout(TIME_MED);
    if (createSavedPanels) {
        await addHeader(page);
        await convertToSavedPanel({
            page,
            name: 'Default - Header',
            section: 'plugins_common_header',
        });
        await addFooter(page);
        await convertToSavedPanel({
            page,
            name: 'Default - Footer',
            section: 'plugins_common_footer',
        });
        await savePage({ page, save: 'save' });
    }
}


/**
 * Click on the page button in the
 * "Choose your starting panel." page
 * @param {Object} page - Page handle.
 */
export async function selectPage(page) {
    const options = { visible: true };
    const buttons = {
        panels: '.svTabs .svTab.panels',
        select: `.panelPane .listContainer 
        [data-id="plugins_common_page"] button`,
    };

    await utils.attempt(async () => {
        await page.click(buttons.panels);
    }, 2);

    await utils.attempt(async () => {
        await page.click(buttons.select);
    }, 2);
}

/**
 * Click on a layout
 * In page panel layouts
 * @param {Object} config - Config object.
 * @param {Object} config.page - Page handle.
* @param {Object} config.title - The title to click.
 */
export async function selectLayout({ page, title }) {
    msg('Selecting layout: ');
    await page.waitForTimeout(TIME_LONG);
    const row = await getRowFromList({
        page,
        rowSel: '.layoutPane .listContainer .bodyRow',
        colSel: '[data-name="name"] .cellWrapper',
        value: title,
    });
    await utils.attempt(async () => {
        await row.evaluate(el => {
            // CMS page context
            el.querySelector('[data-action="selectOnly"]').click();
        });
    }, 2);
}

/**
 * Attempt an action on a selector
 * several times
 * @param {Object} config - The config object.
 * @param {Object} config.page - Page handle.
 * @param {String} config.sel - Selector.
 * @param {Function} config.action - Config object.
 */
export async function waitAndTry({ page, sel, action }) {
    const options = { visible: true };
    await page.waitForSelector(sel, { timeout: 2000, ...options })
        .catch(e => {
            console.error(`waitAndTry error... ${e}
            attempting action again...`);
            throw (e);
        });
    await action();
}

/**
 * Adds a header when editing a page.
 * @param {Object} config - The config object
 * @param {Object} config.page - Page handle.
 * @param {String} config.title  - Titlte of the saved panel.
 */
export async function addSavedHeader({ page, title }) {
    await addToSection({
        page,
        section: 'header',
        type: 'panel',
        widget: 'plugins_common_header',
        smavedPanel: title,
    });
}

/**
 * Adds a header when editing a page.
 * @param {Object} page - Page handle.
 */
export async function addHeader(page) {
    await addToSection({
        page,
        section: 'header',
        type: 'panel',
        widget: 'plugins_common_header',
    });
}

/**
 * Adds a footer when editing a page.
 * @param {Object} page - Page handle.
 */
export async function addFooter(page) {
    await addToSection({
        page,
        section: 'footer',
        type: 'panel',
        widget: 'plugins_common_footer',
    });
}

/**
 * Create a new layout in the CMS, with optional saved panels
 * @param {Object} config Config object.
 * @param {Object} config.page - Page handle.
 * @param {String} config.secion - The section to add.
 * @param {String} config.type - What time of section, header, footer etc.
 * @param {String} config.widget - What widget.
 * @param {String} config.savedPanel - What saved panel to use.
 */
export async function addToSection({ page, section, type, widget, savedPanel }) {
    const options = { visible: true };
    const getType = { panel: 'addPanel', widget: 'add' };
    const buttons = {
        add: `.allowContent[data-name="${section}"] .cmsButton`,
        dropDown: `.allowContent[data-name="${section}"] 
            .addDropdown .${getType[type]}`,
        select: `[data-id="${widget}"] button.cmsButton`,
        saveChanges: '.form-actions button.button_core_submit',
    };

    await page.waitForTimeout(TIME_MED);

    // Header area add button
    await page.waitForSelector(buttons.add, options);
    await page.click(buttons.add);
    await page.waitForTimeout(TIME_SHORT);

    // Click on the drop down
    await page.waitForSelector(buttons.dropDown, options);
    await page.click(buttons.dropDown);

    if (savedPanel) {
        const buttons = {
            saved: '.svTabs .svTab.savedItems',
        };

        // Click on the "saved" tab
        await page.waitForSelector('.plugins_nav_contentOverlay',
            { visible: true });
        page.click(buttons.saved);

        // Select the named header from the list
        const row = await getRowFromList({
            page,
            rowSel: '.listContainer .bodyRow',
            colSel: '[data-name="save_name"]',
            value: 'Microsite',
        });
        await page.evaluate(el => {
            // CMS page context
            el.querySelector('[data-action="selectOnly"]').click();
        }, row);

        await page.waitForTimeout(TIME_MED);
        const canSave = await page.$(buttons.saveChanges);

        if (canSave) {
            await page.click(buttons.saveChanges);
        }
    } else {
        // Click on the select button to select the header panel
        await page.waitForSelector(buttons.select, options);
        await page.click(buttons.select);

        // Wait to load and hit save
        await page.waitForTimeout(TIME_MED);
        const canSave = await page.$(buttons.saveChanges);

        if (canSave) {
            await page.click(buttons.saveChanges);
        }
    }
}

/**
 * Gets the page row from a list of pages
 * @param {Object} config - The config object.
 * @param {Object} config.page - The page handle.
 * @param {String} config.name - The name to select from the list.
 * @return {Object} Element - The element object.
 */
export async function clickPageFromList({ page, name }) {
    return clickItemFromList({
        page,
        rowSel: '[data-type="Page"]',
        colSel: '[data-name="folder"] .cellWrapper',
        value: name,
    });
}

/**
 * Generic click on item in list
 * This particularly clicks on row like lists in
 * the CMS
 * @param {Object} config - The config object.
 * @param {String} config.page - The page hangle.
 * @param {String} config.rowSel - The row to look for in a table.
 * @param {String} config.colSel - The coloumn to look for in a table.
 * @param {String} config.value - Value to look for.
 * @return {Object} Element - The element object.
 */
export async function clickItemFromList({ page, rowSel, colSel, value }) {
    await page.waitForTimeout(TIME_MED);

    let status = false;
    let linksHandle;
    try {
        linksHandle = await getRowFromList({ page, rowSel, colSel, value });
        await linksHandle.evaluate(async el => {
            // CMS page context
            const element = el.querySelector('.multipleDropdown');
            element?.click();
        });
        await linksHandle.evaluate(async el => {
            // CMS page context
            const element = el.querySelector('.action_children');
            element?.click();
        });
        status = true;
    } catch (error) {
        console.error(
            `clickItemFromList: ${error}
            name, ${value}
            linksHandle: ${linksHandle}`,
        );
        throw Error;
    }
    return status;
}

/**
 * Return a row elemnt handle
 * @param {Object} config - Slug name of page.
 * @param {String} config.rowSel - Selector for a row.
 * @param {String} config.colSel - Selector for a column.
 * @param {String} config.value - Value to look for.
 * @return {Object} Handle for element.
 */
async function getRowFromList({ page, rowSel, colSel, value }) {
    //msg("URL", page.url());
    //msg("rowSel", rowSel, "colSel", colSel, "value", value);

    let result = [];
    try {
        result = await page.evaluateHandle(({ rowSel, colSel, value }) => {
            const filtered = [];
            document.querySelectorAll(rowSel).forEach(line => {
                const page = line.querySelector(colSel);
                const anchor = page.querySelector('a');
                if (anchor?.innerHTML === value || page?.innerHTML === value) {
                    filtered.push(line);
                }
            });
            return filtered[0];
        }, { rowSel, colSel, value });
    } catch (error) {
        console.error('Could not get handle from getRowFromList: ${error}');
        throw Error(error);
    }
    return result;
}

/**
 * Click on a panel and convert it to a saved panel
 * @param {Object} config - Config object.
 * @param {Object} config.page - Page handle.
 * @param {String} config.name - What to name the saved panel.
 * @param {String} config.section - Which section to click on.
 */
export async function convertToSavedPanel({ page, name, section }) {
    const options = { visible: true };
    const inputs = {
        name: '[data-name="save_name"] input',
    };
    const buttons = {
        gear: `[data-name="${section}"] .gearArea`,
        convertToSavedPanel: `[data-name="${section}"] .gearDropdown .convert`,
        saveChanges: `.form-actions button.button_core_submit`,
    };

    await page.waitForSelector(buttons.gear, options);
    await page.click(buttons.gear);
    await page.click(buttons.convertToSavedPanel);
    await page.waitForSelector(inputs.name, options);
    await page.type(inputs.name, name);
    await page.click(buttons.saveChanges);
    await page.waitForSelector('.sv_overlay', { hidden: true });
}

/**
 * When editing a page, click on the save button
 * @param {Object} config - Config object.
 * @param {Object} config.page - Page handle.
 * @param {string} config.save - Which save button to click on defaults to "Published"
 */
export async function savePage({ page, save = 'publish' } = {}) {
    const options = { visible: true, timeout: 2000 };
    const buttons = {
        save: `.cmsButtonRow button[data-name="${save}"]`,
    };

    await page.waitForTimeout(TIME_LONG);

    try {
        await utils.attempt(async () => {
            await page.waitForSelector(buttons.save, options);
        }, 2);
        await page.click(buttons.save);
    } catch (error) {
        console.error(`savePage() 
            | failed to save the page with the following error
            :: ${error.message}`);
        throw (error);
    }
}
