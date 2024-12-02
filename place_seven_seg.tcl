#Set seven_segment pins
set seven_seg_0 { C14 E15 C15 C16 E16 D17 C17 } # D15 }
set seven_seg_1 { C18 D18 E18 B16 A17 A18 B17 } # A16 }
set seven_seg_2 { B20 A20 B19 A21 B21 C22 B22 } # A19 }
set seven_seg_3 { F21 E22 E21 C19 C20 D19 E17 } # D22 }
set seven_seg_4 { F18 E20 E19 J18 H19 F19 F20 } # F17 }
set seven_seg_5 { J20 K20 L18 N18 M20 N19 N20 } # L19 }

# TODO: Modify for seven_segment
for { set i 0 } { ${i} < 7 } { incr i } {
	set switch_pin [ lindex ${seven_seg_0} ${i} ]
	set_location_assignment PIN_${switch_pin} -to \
			seven_segment\[0\]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" \
			-to seven_segment\[0\]\[${i}\]
}

for { set i 0 } { ${i} < 7 } { incr i } {
	set switch_pin [ lindex ${seven_seg_1} ${i} ]
	set_location_assignment PIN_${switch_pin} -to \
			seven_segment\[1\]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" \
			-to seven_segment\[1\]\[${i}\]
}

for { set i 0 } { ${i} < 7 } { incr i } {
	set switch_pin [ lindex ${seven_seg_2} ${i} ]
	set_location_assignment PIN_${switch_pin} -to \
			seven_segment\[2\]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" \
			-to seven_segment\[2\]\[${i}\]
}

for { set i 0 } { ${i} < 7 } { incr i } {
	set switch_pin [ lindex ${seven_seg_3} ${i} ]
	set_location_assignment PIN_${switch_pin} -to \
			seven_segment\[3\]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" \
			-to seven_segment\[3\]\[${i}\]
}

for { set i 0 } { ${i} < 7 } { incr i } {
	set switch_pin [ lindex ${seven_seg_4} ${i} ]
	set_location_assignment PIN_${switch_pin} -to \
			seven_segment\[4\]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" \
			-to seven_segment\[4\]\[${i}\]
}

for { set i 0 } { ${i} < 7 } { incr i } {
	set switch_pin [ lindex ${seven_seg_5} ${i} ]
	set_location_assignment PIN_${switch_pin} -to \
			seven_segment\[5\]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" \
			-to seven_segment\[5\]\[${i}\]
}
