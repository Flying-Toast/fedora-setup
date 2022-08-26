const Main = imports.ui.main;

class Extension {
	constructor(uuid) {
		this._uuid = uuid;
	}

	enable() {
		Main.panel.statusArea["a11y"]?.hide();
	}

	disable() {
		Main.panel.statusArea["a11y"]?.show();
	}
}

function init(meta) {
	return new Extension(meta.uuid);
}
