import { UserInputService } from "@rbxts/services";
import beacon from "@rbxts/beacon";

/**
 * This class is the backbone of Rokeys. Whenever you use the RoKeys class' ```newBindFromKeyCode``` method, it creates and returns an
 * object of this class.
 */

export default class Binding {
	private inputs: Enum.KeyCode[];
	private bindName: string;
	private active: boolean;
	private paused: boolean;

	readonly BindActivatedEvent: beacon.Signal<InputObject>; // A readonly attribute which holds the event fired when the binding is activated by one of its inputs.
	readonly BindChangedEvent: beacon.Signal<InputObject>; // WIP
	readonly BindDeactivatedEvent: beacon.Signal<InputObject>; // A readonly attribute which holds the event fired when the binding is no longer being activated by any of its inputs.

	constructor(bindName: string, input?: Enum.KeyCode) {
		this.bindName = bindName;
		this.paused = false;
		this.active = false;

		this.BindActivatedEvent = new beacon.Signal();
		this.BindChangedEvent = new beacon.Signal();
		this.BindDeactivatedEvent = new beacon.Signal();

		UserInputService.InputBegan.Connect((inputObject) => this.activate(inputObject));
		//UserInputService.InputChanged.Connect((inputObject) => this.change(inputObject));
		UserInputService.InputEnded.Connect((inputObject) => this.deactivate(inputObject));

		this.inputs = [];
		if (input) this.inputs.insert(0, input);
	}

	// Sets the name of the binding to the provided string value.
	SetBindName(bindName: string): void {
		this.bindName = bindName;
	}

	// Adds the desired Enum.KeyCode to the binding's table of inputs.
	AddInput(inputToAdd: Enum.KeyCode): void {
		if (this.inputs.includes(inputToAdd)) return;
		this.inputs.insert(0, inputToAdd);
	}

	// Removes the desired Enum.KeyCode from the binding's table of inputs.
	RemoveInput(inputToRemove: Enum.KeyCode): void {
		for (let i = 0; i < this.inputs.size(); i++) {
			if (this.inputs[i] === inputToRemove) this.inputs.remove(i);
		}
	}

	// Pauses or unpauses the binding, only stops the binding from being activated
	SetPaused(value: boolean) {
		this.paused = value;
	}

	// Returns the name of the Binding as a string.
	GetBindName(): string {
		return this.bindName;
	}

	// Returns an array of Enum.KeyCode containing all inputs given to the binding.
	GetInputs(): Enum.KeyCode[] {
		return this.inputs;
	}

	// Returns whether or not the binding is being activated by one of it's inputs.
	IsActive(): boolean {
		return this.active;
	}

	// Returns whether or not the bindind has been paused.
	IsPaused(): boolean {
		return this.paused;
	}

	private activate(input: InputObject): void {
		if (this.active || this.paused) return;
		if (!this.HasInput(input.KeyCode)) return;

		this.active = true;
		this.BindActivatedEvent.Fire(input);
	}

	private change(input: InputObject): void {
		if (!this.HasInput(input.KeyCode)) return;

		this.BindChangedEvent.Fire(input); //TODO: Temporary behavior, event is completely unfinished.
	}

	private deactivate(input: InputObject): void {
		if (!this.active) return;
		if (!this.HasInput(input.KeyCode)) return;

		for (const keyCode of this.inputs) {
			if (UserInputService.IsKeyDown(keyCode)) {
				return;
			}
		}

		this.active = false;

		this.BindDeactivatedEvent.Fire(input);
	}

	// Takes an Enum.KeyCode and determines if it is an input given to the binding, returns true if it is found and false is not.
	HasInput(inputToCheck: Enum.KeyCode): boolean {
		let inputExists = false;

		for (const input of this.inputs) {
			if (input === inputToCheck) {
				inputExists = true;
				break;
			}
		}

		return inputExists;
	}

	// Destroys all events associated with the binding and clears the table of inputs, essentially making the binding unusable.
	Disconnect(): void {
		this.BindActivatedEvent.Destroy();
		this.BindChangedEvent.Destroy();
		this.BindDeactivatedEvent.Destroy();

		this.inputs = [];
	}
}
