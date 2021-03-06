Class {
	#name : #BPLangtonAntCodeGenerator,
	#superclass : #Object,
	#category : #'BytePusher-Assembler-Examples'
}

{ #category : #'code generation' }
BPLangtonAntCodeGenerator >> generate [
	| assembly |
	assembly := BPAssembler new.
	self generateOn: assembly.
	^ assembly
]

{ #category : #'code generation' }
BPLangtonAntCodeGenerator >> generateInversePixelValueOn: assembly [
	assembly
		label: #inverse_pixel_value;
		popFromDataStack: #A; "pixel value"
		cmp: #A with: 0;
		jumpIfNotEqual: #inverse_pixel_value_not_zero;
		pushOnDataStack: 215;
		return;
		
		label: #inverse_pixel_value_not_zero;
		pushOnDataStack: 0;
		return
]

{ #category : #'code generation' }
BPLangtonAntCodeGenerator >> generateLangtonAntOn: assembly [
	assembly
		label: #langton_ant;
		popFromDataStack: #A;
		popFromDataStack: #B;
		popFromDataStack: #C;
		"Backup A, B and C"
		pushOnDataStack: #C;
		pushOnDataStack: #B;
		pushOnDataStack: #A;
		"Arguments for read pixel"
		pushOnDataStack: #B;
		pushOnDataStack: #A;
		call: #read_current_pixel_value; 
		"Top of the stack now contains pixel value."
		call: #inverse_pixel_value;
		"Top of the stack now contains inverted pixel value."
		popFromDataStack: #C; "Inverted pixel value is now in C"
		popFromDataStack: #A; "x"
		popFromDataStack: #B; "y"
		"Backup values"
		pushOnDataStack: #B; "x"
		pushOnDataStack: #A; "y"
		pushOnDataStack: #C; "Inverted pixel value"
		"Arguments of #write_pixel_value"
		pushOnDataStack: #C; "Push inverted pixel value as argument"
		pushOnDataStack: #B; "x"
		pushOnDataStack: #A; "y"
		call: #write_pixel_value;
		popFromDataStack: #C;
		popFromDataStack: #A;
		popFromDataStack: #B;
		popFromDataStack: #D;
		pushOnDataStack: #B;
		pushOnDataStack: #A;
		pushOnDataStack: #D;
		pushOnDataStack: #C;
		call: #turn;
		popFromDataStack: #C;
		popFromDataStack: #A;
		popFromDataStack: #B;
		"Backup orientation for next iteration."
		pushOnDataStack: #C;
		"Pass argument to #next_ant_position."
		pushOnDataStack: #C;
		pushOnDataStack: #B;
		pushOnDataStack: #A;
		call: #next_ant_position;
		return
]

{ #category : #'code generation' }
BPLangtonAntCodeGenerator >> generateNextAntPositionOn: assembly [
	assembly
		label: #next_ant_position;
		"x,y=0,0 is top-left"
		popFromDataStack: #A; "x position on the screen"
		popFromDataStack: #B; "y position on the screen"
		popFromDataStack: #C; "Direction included in [0,3]"
		cmp: #C with: 0;
		jumpIfEqual: #next_ant_position_go_north;
		cmp: #C with: 1;
		jumpIfEqual: #next_ant_position_go_east;
		cmp: #C with: 2;
		jumpIfEqual: #next_ant_position_go_south;
		cmp: #C with: 3;
		jumpIfEqual: #next_ant_position_go_west;
		"Should not reach this point!"
		
		label: #next_ant_position_go_north;
		decrement: #B;
		pushOnDataStack: #B;
		pushOnDataStack: #A;
		return;
		label: #next_ant_position_go_south;
		increment: #B;
		pushOnDataStack: #B;
		pushOnDataStack: #A;
		return;
		label: #next_ant_position_go_east;
		increment: #A;
		pushOnDataStack: #B;
		pushOnDataStack: #A;
		return;
		label: #next_ant_position_go_west;
		decrement: #A;
		pushOnDataStack: #B;
		pushOnDataStack: #A;
		return
]

{ #category : #'code generation' }
BPLangtonAntCodeGenerator >> generateOn: assembly [
	"Read"
	"Inverse color"
	"Write new color"
	"Decide direction"
	"Move ant"
	assembly
		label: #initialize;
			serializePC: #iterate;
			move: 127 to: #A; "X"
			move: 127 to: #B; "Y"
			move: 0 to:  #C; "North"
			"Backup A, B and C"
			pushOnDataStack: #C;
			pushOnDataStack: #B;
			pushOnDataStack: #A;
			"At the end of initialization, 3 values are on the data stack (from top to bottom):
			- x position
			- y position
			- orientation
			"
			jump: #end;
		
		label: #iterate;
			call: #langton_ant;
			jump: #end.
			
	self generateTurnLeftOn: assembly.
	self generateTurnRightOn: assembly.
	self generateTurnOn: assembly.
	self generateReadCurrentPixelValueOn: assembly.
	self generateNextAntPositionOn: assembly.
	self generateInversePixelValueOn: assembly.
	self generateWritePixelValueOn: assembly.
	self generateLangtonAntOn: assembly.
	
	assembly
		label: #end;
		nop.
]

{ #category : #'code generation' }
BPLangtonAntCodeGenerator >> generateReadCurrentPixelValueOn: assembly [
	assembly
		label: #read_current_pixel_value;
		popFromDataStack: #B; "x position on the screen"
		popFromDataStack: #A; "y position on the screen"
		readPixel;
		pushOnDataStack: #A;
		return
]

{ #category : #'code generation' }
BPLangtonAntCodeGenerator >> generateTurnLeftOn: assembly [
	assembly
		label: #turn_left;
		"North = 0"
		"East  = 1"
		"South = 2"
		"West  = 3"
		popFromDataStack: #A; "Precondition: current orientation included in [0,3]"
		cmp: #A with: 0;
		jumpIfEqual: #turn_left_is_zero;
		decrement: #A;
		pushOnDataStack: #A;
		return;
		
		label: #turn_left_is_zero;
			pushOnDataStack: 3;
			return.
]

{ #category : #'code generation' }
BPLangtonAntCodeGenerator >> generateTurnOn: assembly [
	"Arguments on the stack expected by the subroutine:
	
		Inverted pixel value <- top of the stack
		previous orientation
		
	 As result, pushes the new orientation on the stack.
	"
	assembly
		label: #turn;
		popFromDataStack: #C; "Pixel value inverted."
		"Top of the stack is previous orientation"
		cmp: #C with: 0; "Since it is inverted it means, it was white."
		jumpIfEqual: #color_white;
		"Else, it was black."
			call: #turn_left;
			return;
		label: #color_white;"Turn right"
			call: #turn_right;
			return
]

{ #category : #'code generation' }
BPLangtonAntCodeGenerator >> generateTurnRightOn: assembly [
	assembly
		label: #turn_right;
		"North = 0"
		"East  = 1"
		"South = 2"
		"West  = 3"
		popFromDataStack: #A; "Precondition: current orientation included in [0,3]"
		cmp: #A with: 3;
		jumpIfEqual: #turn_right_is_three;
		increment: #A;
		pushOnDataStack: #A;
		return;
		
		label: #turn_right_is_three;
			pushOnDataStack: 0;
			return.
]

{ #category : #'code generation' }
BPLangtonAntCodeGenerator >> generateWritePixelValueOn: assembly [
	assembly
		label: #write_pixel_value;
		popFromDataStack: #B; "x position on the screen"
		popFromDataStack: #A; "y position on the screen"
		popFromDataStack: #C; "pixel value"
		writePixel: #C;
		return
]
