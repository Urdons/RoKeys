import Binding from "./Binding";

/**
 * The rokeys Input Service
 */

export default class RoKeys {
	private readonly bindingMap: Binding[];

	constructor() {
		this.bindingMap = [];
	}

	public newBindFromKeyCode(bindName: string, KeyCode?: Enum.KeyCode): Binding {
		if (this.bindingExists(bindName)) {
			error(
				"The binding with the name '" +
					bindName +
					"' already exists. Instead add the input to the bind with addInputToBind()",
				2,
			);
		}

		const newBinding = new Binding(bindName, KeyCode);

		this.bindingMap.insert(0, newBinding);
		print(this.bindingMap);

		return newBinding;
	}

	public removeBind(bindName: string): void {
		//TODO
	}

	public getBindFromName(bindName: string): Binding | undefined {
		for (const bind of this.bindingMap) {
			if (bind.getBindName() === bindName) return bind;
		}

		return undefined;
	}

	private bindingExists(bindName: string): boolean {
		let exists = false;

		for (const bind of this.bindingMap) {
			if (bind.getBindName() === bindName) {
				exists = true;
				break;
			}
		}

		return exists;
	}
}
