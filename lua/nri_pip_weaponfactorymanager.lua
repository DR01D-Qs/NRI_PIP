function WeaponFactoryManager:get_stance_mod(factory_id, blueprint, using_second_sight)
	local factory = tweak_data.weapon.factory
	local assembled_blueprint = self:get_assembled_blueprint(factory_id, blueprint)
	local forbidden = self:_get_forbidden_parts(factory_id, assembled_blueprint)
	local override = self:_get_override_parts(factory_id, assembled_blueprint)
	local part = nil
	local translation = Vector3()
	local rotation = Rotation()
	local is_not_sight_type, is_weapon_sight, is_second_sight = nil
	local second_sight_id = using_second_sight

	for _, part_id in ipairs(assembled_blueprint) do
		if not forbidden[part_id] then
			part = self:_part_data(part_id, factory_id, override)

			if part.stance_mod then
				is_not_sight_type = part.type ~= "sight" and part.type ~= "second_sight" and part.sub_type ~= "second_sight" or false
				is_weapon_sight = not second_sight_id and part.type == "sight" or false
				is_second_sight = second_sight_id and part_id == second_sight_id or false

				if (is_not_sight_type or is_weapon_sight or is_second_sight) and part.stance_mod[factory_id] then
					local part_translation = part.stance_mod[factory_id].translation
					part_translation = Vector3(part_translation.x, 0, part_translation.z)

					if part_translation then
						mvector3.add(translation, part_translation)
					end

					local part_rotation = part.stance_mod[factory_id].rotation

					if part_rotation then
						mrotation.multiply(rotation, part_rotation)
					end
				end
			end
		end
	end

	return {
		translation = translation,
		rotation = rotation
	}
end