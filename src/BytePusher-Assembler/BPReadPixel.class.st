Class {
	#name : #BPReadPixel,
	#superclass : #BPAssemblerInstruction,
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPReadPixel >> generateFor: anAssembler [
	| instruction1 instruction2 instruction3 |
	instruction1 := self newInstruction
		from: (anAssembler registerNamed: #A);
		yourself.
	instruction2 := self newInstruction
		from: (anAssembler registerNamed: #B);
		yourself.
	instruction3 := self newInstruction
		from: (anAssembler reservedMemoryZoneNamed: #DISPLAY_FRAME) address;
		to: (anAssembler registerNamed: #A);
		yourself.
	instruction1
		to: (instruction3 asReference offset: 1);
		jump: instruction2 asReference;
		beAddedTo: anAssembler.
	instruction2
		to: (instruction3 asReference offset: 2);
		jump: instruction3 asReference;
		beAddedTo: anAssembler.
	instruction3
		jump: BPNextInstructionReference new;
		beAddedTo: anAssembler.
]
