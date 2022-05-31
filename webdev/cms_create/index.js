/* eslint-disable arrow-parens */
import 'dotenv/config';
import puppeteer from 'puppeteer';
import * as cms from './createLib.js';
import * as layout from './createLayout.js';
import { PendingXHR } from 'pending-xhr-puppeteer';
import * as structure from './createStructure.js';
import msg from './msg.js';

const options = {
    client: 'base-a-a0faf69e',
    env: 'staging',
    site: 'primary',
    user: process.env.CMSUSER,
    password: process.env.PASSWORD,
};

(async () => {
    const evn = { live: '', staging: 'staging' };
    const home = `https://${options.client}.${evn[options.env]}.simpleviewcms.com`;
    const pages = {
        layout: `${home}/nav/settings/sites/${options.site}/layouts/`,
        systemPageCreate:
            `${home}/nav/sitemap/site_${options.site}/section_system/`,
    };

    msg('Starting puppeteer...');

    const browser = await puppeteer.launch({
        headless: false,
        args: [
            '--window-size=800,700',
        ],
    });
    const page = (await browser.pages())[0];

    await cms.login({
        page,
        location: home,
        user: options.user,
        password: options.password,
    });

    await page.waitForTimeout(1000);

    // The name of the new layout
    const layoutName = "Redesign - Default";

    // The pages to create. 
    const structurePaths = [
        '/svtest3/collections/misc',
        '/svtest3/prototype-pages/homepage',
        '/svtest3/prototype-pages/listings',
    ];

    await page.goto(pages.layout);
    await page.waitForTimeout(1000);

    await layout.createLayout({
        page,
        layoutPage: pages.layout,
        name: layoutName,
        cms
    });

    await page.waitForTimeout(1000);

    await structure.createStructure({
        page,
        cms,
        config: structurePaths,
        sectionPage: pages.systemPageCreate,
        layoutName 
    })
    // await browser.close();
})();

