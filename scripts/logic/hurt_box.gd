extends Area2D

@export var damage = 1


func _on_body_entered(body: Node2D) -> void:
	body.call_deferred("take_damage", damage, (position - body.position).normalized())
