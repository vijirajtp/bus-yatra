module UserHelper
	def full_name
		(current_user.first_name.blank? || current_user.last_name.blank?) ? current_user.email : current_user.first_name + ' ' + current_user.last_name
	end
end
