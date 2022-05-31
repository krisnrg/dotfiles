
/**
 * Create a new layout in the CMS, with optional saved panels
 * @param {Object} page - The page handle.
 * @param {string} name - The name of the layout
 * @param {string} layoutPage - URL localtion of the layout page
 * @param {object} cms - The createLib object
 */
export async function createLayout({page, name, layoutPage, cms}) {
    await cms.createNewLayout({
        layoutPage: layoutPage,
        name: name,
        page,
    });
}
