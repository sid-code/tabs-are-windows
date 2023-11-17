(async function () {
    browser.tabs.onCreated.addListener(async function (tab) {
	// If we let the first tab of any window trigger this, it
	// would keep triggering itself infinitely.
	if (tab.index == 0) {
	    return;
	}

	const newW = await browser.windows.create();

	// Move the tab to the last position in the new window
	await browser.tabs.move([tab.id], {windowId: newW.id, index: -1});

	// Close the first tab
	await browser.tabs.remove(newW.tabs[0].id);
    });
})();
