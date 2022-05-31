/**
 * Block requests
 * @param {Object} page - Page handle.
 * @param {Array} list - Array of things to block.
 */
export async function blockRequests(page, list = defaultList()) {
    await page.setRequestInterception(true);
    page.on('request', (request) => {
        list.forEach((elem) => {
            if (request.url().includes(elem) ) {
                request.abort();
            } else {
                request.continue();
            }
        });
    });
}

/**
 * Default list of things to block
 * Used in the block requests function
 * @param {Object} page - Page handle.
 * @param {array} list - Array of things to block.
 * @return {array} Array of things to block
 */
function defaultList() {
    return [
        'doubleclick',
        'google-analytics',
        'facebook',
        'twitter',
        'googlesyndication',
    ];
}

