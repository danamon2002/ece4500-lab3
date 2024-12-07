#Set seven_segment pins
set seven_seg {	{ C14 E15 C15 C16 E16 D17 C17 } \
		{ C18 D18 E18 B16 A17 A18 B17 } \
		{ B20 A20 B19 A21 B21 C22 B22 } \
		{ F21 E22 E21 C19 C20 D19 E17 } \
		{ F18 E20 E19 J18 H19 F19 F20 } \
		{ J20 K20 L18 N18 M20 N19 N20 } \
	}


# TODO: Modify for seven_segment
for { set i 0 } { ${i} < 6 } { incr i } {
	set pinout [ lindex ${seven_seg} ${i} ]
	foreach { idx seg } { 0 a 1 b 2 c 3 d 4 e 5 f 6 g } {
		set switch_pin [ lindex ${pinout} ${idx} ]
		set_location_assignment PIN_${switch_pin} -to \
				seven_segment\[${i}\].${seg}
		set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" \
				-to seven_segment\[${i}\].${seg}
	}
}

foreach { signal pin } { clock_main P11 clock_adc N5 } {
	set_location_assignment PIN_${pin} -to ${signal}
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to ${signal}
}

set_location_assignment PIN_B8 -to reset
set_instance_assignment -name IO_STANDARD "3.3 V SCHMITT TRIGGER" -to reset

#
#for { set i 0 } { ${i} < 7 } { incr i } {
#	set switch_pin [ lindex ${seven_seg_1} ${i} ]
#	set_location_assignment PIN_${switch_pin} -to \
#			seven_segment\[1\]
#	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" \
#			-to seven_segment\[1\]\[${i}\]
#}
#
#for { set i 0 } { ${i} < 7 } { incr i } {
#	set switch_pin [ lindex ${seven_seg_2} ${i} ]
#	set_location_assignment PIN_${switch_pin} -to \
#			seven_segment\[2\]
#	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" \
#			-to seven_segment\[2\]\[${i}\]
#}
#
#for { set i 0 } { ${i} < 7 } { incr i } {
#	set switch_pin [ lindex ${seven_seg_3} ${i} ]
#	set_location_assignment PIN_${switch_pin} -to \
#			seven_segment\[3\]
#	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" \
#			-to seven_segment\[3\]\[${i}\]
#}
#
#for { set i 0 } { ${i} < 7 } { incr i } {
#	set switch_pin [ lindex ${seven_seg_4} ${i} ]
#	set_location_assignment PIN_${switch_pin} -to \
#			seven_segment\[4\]
#	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" \
#			-to seven_segment\[4\]\[${i}\]
#}
#
#for { set i 0 } { ${i} < 7 } { incr i } {
#	set switch_pin [ lindex ${seven_seg_5} ${i} ]
#	set_location_assignment PIN_${switch_pin} -to \
#			seven_segment\[5\]
#	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" \
#			-to seven_segment\[5\]\[${i}\]
#}
