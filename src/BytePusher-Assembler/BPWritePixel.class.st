"
Writes #pixelValue on the pixel at the address pointed by 16bits address formed by A and B registers.

A register holds middle byte for address.
B register holds lower byte for address.
"
Class {
	#name : #BPWritePixel,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'pixelValue'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPWritePixel >> generateFor: anAssembler [
	| instruction1 instruction2 instruction3 |
	instruction1 := self newInstruction
		from: (anAssembler registerNamed: #A);
		yourself.
	instruction2 := self newInstruction
		from: (anAssembler registerNamed: #B);
		yourself.
	instruction3 := self newInstruction
		from: (self pixelValue forAssembler: anAssembler);
		to: (anAssembler reservedMemoryZoneNamed: #DISPLAY_FRAME) address;
		yourself.
	instruction1
		to: (instruction3 asReference byteIndex: 4);
		jump: instruction2 asReference;
		beAddedTo: anAssembler.
	instruction2
		to: (instruction3 asReference byteIndex: 5);
		jump: instruction3 asReference;
		beAddedTo: anAssembler.
	instruction3
		jump: BPNextInstructionReference new;
		beAddedTo: anAssembler.
]

{ #category : #accessing }
BPWritePixel >> pixelValue [
	^ pixelValue
]

{ #category : #accessing }
BPWritePixel >> pixelValue: anObject [
	pixelValue := anObject
]
