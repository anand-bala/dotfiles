# function myroshook --on-variable ROS_DISTRO -d "Source the ROS environment hooks when activating the distro"
#   # Check the ROS version
#   if test "$ROS_VERSION" = "1"
#     source /opt/ros/$ROS_DISTRO/share/rosbash/rosfish
#   else if test "$ROS_VERSION" = "2"
#     and command -sq ros2
#     register-python-argcomplete --shell fish ros2 | source
#   end
# end
