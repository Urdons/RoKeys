import RoKeys from "shared/Rokeys";

const up = RoKeys.CreateBinding("Up", Enum.KeyCode.W);
const down = RoKeys.CreateBinding("Down", Enum.KeyCode.S);
const left = RoKeys.CreateBinding("Left", Enum.KeyCode.A);
const right = RoKeys.CreateBinding("Right", Enum.KeyCode.D);
up.AddInput(Enum.KeyCode.Up);

while (true) {
	print(RoKeys.GetVector2(left, right, down, up, true));
	wait(0.1);
}
