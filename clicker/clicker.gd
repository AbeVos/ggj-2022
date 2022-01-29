extends Node2D


var click_all = false
var ignore_unclickable = true


func _input(event: InputEvent):
	if (
		event is InputEventMouseButton
		and event.pressed
		and event.button_index == 1
	):
		var shapes = get_world_2d().direct_space_state.intersect_point(
			event.position,
			32,
			[],
			0x7FFFFFFF,
			true,
			true)
			# The last 'true' enables Area2D intersections, previous
			# four values are all defaults

		for shape in shapes:
			var collider = shape["collider"]

			# Check if we have collided with a HandCard.
			if collider.get_parent().has_method("on_click"):
				collider.get_parent().on_click()

				if !click_all and ignore_unclickable:
					break
					# Thus clicks only the topmost clickable

			if !click_all and !ignore_unclickable:
				break
				# Thus stops on the first shape
