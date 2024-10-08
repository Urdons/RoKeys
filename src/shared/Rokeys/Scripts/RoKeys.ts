import Binding from "./Binding";

/**
 * When importing RoKeysService this is the class you are given. This class contains various methods for handling Bindings.
 */

export default class RoKeys {
	private readonly bindingMap: Binding[];

	constructor() {
		this.bindingMap = [];
	}

	// Creates a new Binding using a string as the name and, if provided, adds an Enum.Keycode as an input.
	public CreateBinding(bindName: string, KeyCode?: Enum.KeyCode): Binding {
		if (this.BindingExists(bindName)) {
			error(
				"The binding with the name '" +
					bindName +
					"' already exists. Instead add the input to the bind with addInputToBind()",
				2,
			);
		}

		const newBinding = new Binding(bindName, KeyCode);

		this.bindingMap.insert(0, newBinding);

		return newBinding;
	}

	// WIP
	public RemoveBinding(bindName: string): void {
		//TODO
	}

	// Returns a Binding using the provided string as the name to look for (case sensitive), if there is no bind with that name then the function returns undefined.
	public GetBindingFromName(bindName: string): Binding | undefined {
		for (const bind of this.bindingMap) {
			if (bind.GetBindName() === bindName) return bind;
		}

		return undefined;
	}

	private BindingExists(bindName: string): boolean {
		let exists = false;

		for (const bind of this.bindingMap) {
			if (bind.GetBindName() === bindName) {
				exists = true;
				break;
			}
		}

		return exists;
	}

	// Takes four bindings which will act as negative and positive influences on both the x and y parts of a vector2. The returned
	// vector2 is normalized (has a magnitude of one), but this behavior can be overridden with the optional boolean dontNormalize parameter.
	public GetVector2(
		negativeX: Binding,
		positiveX: Binding,
		negativeY: Binding,
		positiveY: Binding,
		dontNormalize?: boolean,
	) {
		let vector: Vector2 = new Vector2(0, 0);

		if (negativeX.IsActive()) vector = vector.add(new Vector2(-1, 0));
		if (positiveX.IsActive()) vector = vector.add(new Vector2(1, 0));
		if (negativeY.IsActive()) vector = vector.add(new Vector2(0, -1));
		if (positiveY.IsActive()) vector = vector.add(new Vector2(0, 1));

		if (!dontNormalize && !(vector.X === 0 && vector.Y === 0)) vector = vector.Unit;

		return vector;
	}
}
