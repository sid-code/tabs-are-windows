(async function () {
    browser.tabs.onCreated.addListener(async function (tab) {
	if (tab.index > 0) {
	    const newW = await browser.windows.create();
	    await browser.tabs.move([tab.id], {windowId: newW.id, index: -1});
	    await browser.tabs.remove(newW.tabs[0].id);
	}
    });
})();
