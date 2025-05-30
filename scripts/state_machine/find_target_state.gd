extends Node2D
class_name FindTargetState

## Class is a state to be added to a parent state machine as a possible state,
## Node must have parent of state machine.
## This state finds a target in `detection_area`, notifies the `target_tracker`,
## and passes state to the state in `detected_state`
##
## Use in enemies that need to find a target, usually you want to set the
## collision mask of the detection area to only player collision layer
## or minion and player collision layer.

@export var target_tracker: TargetTracker = null;
@export var detection_area: Area2D = null;
@export var detected_state: String = "";
@export var animation: StringName = "";
@export var transition_animation: StringName = "";
@export var animation_player: AnimationPlayer;

# Finds target and swaps parent state when target is found
func physics_process(_delta: float) -> void:
	self.animation_player.play(animation);
	if randf() < .1:
		var nearest: Node2D = CollisionDetectionHelper.get_hit_nearest_body(self.detection_area);
		if nearest != null:
			self.on_body_enter_detection(nearest);

func on_body_enter_detection(body: Node2D):
	if !StateMachine.is_active_state(self):
		return;
	target_tracker.set_target(body);
	StateMachine.switch_state(self, detected_state);
	self.animation_player.play(transition_animation);
