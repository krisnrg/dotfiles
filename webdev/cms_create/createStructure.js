
/**
 * Create a new layout in the CMS, with optional saved panels
 * @param {Object} config - The config object. 
 * @param {Object} config.page - The page handle.
 * @param {Object} config.cms - The createLib object.
 * @param {Array} config.config .- An array of paths to create. TODO: rename this
 * @param {String} config.layoutName - The name of the layout to add.
 * @param {String} config.sectionPage - The URL for the section page.
 */
export async function createStructure({page, cms, config, layoutName, sectionPage}) {
    // each config item is a path example: /svtest/somenav/title 
    console.log('layoutName', layoutName);
    for( const path of config) {
        console.log('createStructure: for of, current path: ', path);
        await page.goto(sectionPage);
        await page.waitForTimeout(1000);
        await cms.followPath({page, path: path, layoutName}); 
    }
}
