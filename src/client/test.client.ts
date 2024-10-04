import RoKeysService from "shared/Rokeys";

const left = RoKeysService.newBindFromKeyCode("Left", Enum.KeyCode.A);
const up = RoKeysService.newBindFromKeyCode("Up", Enum.KeyCode.W);
up.addInput(Enum.KeyCode.Up);

up.bindActivated.Connect((inputObject) => print("go up", inputObject.KeyCode));
left.bindActivated.Connect((inputObject) => print("left", inputObject.KeyCode));
