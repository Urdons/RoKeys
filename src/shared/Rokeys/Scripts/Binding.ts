import { UserInputService } from "@rbxts/services";
import beacon from "@rbxts/beacon";

export default class Binding {
	private inputs: Enum.KeyCode[];
	private bindName: string;
	readonly bindActivated: beacon.Signal<InputObject>;
	readonly bindChanged: beacon.Signal<InputObject>;
	readonly bindDeactivated: beacon.Signal<InputObject>;

	constructor(bindName: string, input?: Enum.KeyCode) {
		this.bindName = bindName;

		this.bindActivated = new beacon.Signal();
		this.bindChanged = new beacon.Signal();
		this.bindDeactivated = new beacon.Signal();

		UserInputService.InputBegan.Connect((inputObject) => this.activateBind(inputObject));
		UserInputService.InputChanged.Connect((inputObject) => this.changeBind(inputObject));
		UserInputService.InputBegan.Connect((inputObject) => this.deactivateBind(inputObject));

		this.inputs = [];
		if (input) this.inputs.insert(0, input);
	}

	setBindName(bindName: string): void {
		this.bindName = bindName;
	}

	addInput(inputToAdd: Enum.KeyCode): void {
		if (this.inputs.includes(inputToAdd)) return;
		this.inputs.insert(0, inputToAdd);
	}

	removeInput(inputToRemove: Enum.KeyCode): void {
		for (let i = 0; i < this.inputs.size(); i++) {
			if (this.inputs[i] === inputToRemove) this.inputs.remove(i);
		}
	}

	getBindName(): string {
		return this.bindName;
	}

	getInputs(): Enum.KeyCode[] {
		return this.inputs;
	}

	private activateBind(input: InputObject) {
		if (!this.hasInput(input.KeyCode)) return;

		this.bindActivated.Fire(input); //TODO: For activate and deactivate, improve behavior by making use of state machine!!!
	}

	private changeBind(input: InputObject) {
		if (!this.hasInput(input.KeyCode)) return;

		this.bindChanged.Fire(input); //TODO: Temporary behavior, event is completely unfinished.
	}

	private deactivateBind(input: InputObject) {
		if (!this.hasInput(input.KeyCode)) return;

		this.bindDeactivated.Fire(input);
	}

	hasInput(inputToCheck: Enum.KeyCode): boolean {
		let inputExists = false;

		for (const input of this.inputs) {
			if (input === inputToCheck) {
				inputExists = true;
				break;
			}
		}

		return inputExists;
	}

	disconnect(): void {
		this.bindActivated.Destroy();
		this.bindChanged.Destroy();
		this.bindDeactivated.Destroy();

		this.inputs = [];
	}
}
