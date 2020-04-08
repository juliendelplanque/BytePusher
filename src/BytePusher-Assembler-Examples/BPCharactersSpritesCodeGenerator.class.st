Class {
	#name : #BPCharactersSpritesCodeGenerator,
	#superclass : #Object,
	#category : #'BytePusher-Assembler-Examples'
}

{ #category : #generating }
BPCharactersSpritesCodeGenerator >> generate [
	| assembly |
	assembly := BPAssembler new.
	self generateOn: assembly.
	^ assembly
]

{ #category : #generating }
BPCharactersSpritesCodeGenerator >> generateDataOn: assembler [
	assembler
	jump: #data_end;
	label: #sprite_0;
	data: #[ 0  215  0
		     215  0  215
			  215  0  215
			  215  0  215
			   0  215  0];
	label: #sprite_1;
	data: #[ 0  215  0
		     215 215  0
		      0  215  0
		      0  215  0
		      0  215  0];
	label: #sprite_2;
	data: #[ 0  215  0
		     215  0  215
		      0   0  215
		      0  215  0
		     215 215 215];
	label: #sprite_3;
	data: #[215 215  0
		      0   0  215
		      0  215 215
		      0   0  215
		     215 215  0];
	label: #sprite_4;
	data: #[215  0   0
		     215  0  215
		     215 215 215
		      0   0  215
		      0   0  215];
	label: #sprite_5;
	data: #[215 215 215
		     215  0   0
		     215 215  0
		      0   0  215
		     215 215 215];
	label: #sprite_6;
	data: #[ 0  215 215
		     215  0   0
		     215 215 215
		     215  0  215
		     215 215 215];
	label: #sprite_7;
	data: #[215 215 215
		      0   0  215
		      0  215  0
		     215  0   0
		     215  0   0];
	label: #sprite_8;
	data: #[ 0  215  0
		     215  0  215
		      0  215  0
		     215  0  215
		      0  215  0];
	label: #sprite_8;
	data: #[215 215 215
		     215  0  215
		     215 215 215
		      0   0  215
		     215 215 215];
	label: #data_end
]

{ #category : #generating }
BPCharactersSpritesCodeGenerator >> generateDisplaySpriteLineOn: assembler [
	assembler label: #display_sprite_line;
		call: #display_sprite_pixel;
		increment: #B;
		call: #display_sprite_pixel;
		increment: #B;
		call: #display_sprite_pixel;
		decrement: #B;
		decrement: #B;
		return
]

{ #category : #generating }
BPCharactersSpritesCodeGenerator >> generateDisplaySpriteOn: assembler [
	assembler label: #display_sprite;
		call: #display_sprite_line;
		increment: #A;
		call: #display_sprite_line;
		increment: #A;
		call: #display_sprite_line;
		increment: #A;
		call: #display_sprite_line;
		increment: #A;
		call: #display_sprite_line;
		decrement: #A;
		decrement: #A;
		decrement: #A;
		decrement: #A;
		return
]

{ #category : #generating }
BPCharactersSpritesCodeGenerator >> generateDisplaySpritePixelOn: assembler [
	assembler label: #display_sprite_pixel;
		move: #A to: #D;
		move: #B to: #E;
		popFromDataStack: #C;
		popFromDataStack: #B;
		popFromDataStack: #A;
		fetchDataAtAddressInto: #F;
		incrementAddress;
		pushOnDataStack: #A;
		pushOnDataStack: #B;
		pushOnDataStack: #C;
		move: #D to: #A;
		move: #E to: #B;
		writePixel: #F;
		return
]

{ #category : #generating }
BPCharactersSpritesCodeGenerator >> generateOn: assembler [
	
	self
		generateDataOn: assembler;
		generateDisplaySpritePixelOn: assembler;
		generateDisplaySpriteLineOn: assembler;
		generateDisplaySpriteOn: assembler.
]
