"
Adds two numbers together and store result in source register.
This operations will modify the carry and zero flag. 
SP can be used as operand with ADD.

ADD reg, reg
ADD reg, address
ADD reg, constant
"
Class {
	#name : #BPAdd,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'source',
		'target'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPAdd >> generateFor: anAssembler [
	| sourceForAssembler targetForAssembler instruction1 instruction2 instruction3 instruction4 instruction5 instruction6 instruction7 instruction8 instruction9 |
	sourceForAssembler := self source forAssembler: anAssembler.
	targetForAssembler := self target forAssembler: anAssembler.
	"First, copy data at fromAddress to location of the add, carry and zero instructions."
	instruction1 := self newInstruction
		from: sourceForAssembler;
		beAddedTo: anAssembler.
	instruction2 := self newInstruction
		from: sourceForAssembler;
		beAddedTo: anAssembler.
	instruction3 := self newInstruction
		from: sourceForAssembler;
		beAddedTo: anAssembler.
	"Second, copy data at toAddress to location of the add, carry and zero instructions."
	instruction4 := self newInstruction
		from: targetForAssembler;
		beAddedTo: anAssembler.
	instruction5 := self newInstruction
		from: targetForAssembler;
		beAddedTo: anAssembler.
	instruction6 := self newInstruction
		from: targetForAssembler;
		beAddedTo: anAssembler.
	"Third, create the actual add instruction (beware the 16 least
	 significant bit of the #from address
	 will be set by the 2 previous instructions, so they it will be
	 overwritten at runtime whatever what is written on it).
	"
	instruction7 := self newInstruction
		from: (anAssembler reservedMemoryZoneNamed: #ADD_PAGE);
		to: sourceForAssembler;
		beAddedTo: anAssembler.
	"Fourth, create the actual carry flag instruction (beware the 16 least
	 significant bit of the #from address
	 will be set by the 2 previous instructions, so they it will be
	 overwritten at runtime whatever what is written on it).
	"
	instruction8 := self newInstruction
		from: (anAssembler reservedMemoryZoneNamed: #ADD_CARY_FLAG_PAGE);
		to: (anAssembler registerNamed: #CARRY);
		beAddedTo: anAssembler.
	"Third, create the actual zero flag instruction (beware the 16 least
	 significant bit of the #from address
	 will be set by the 2 previous instructions, so they it will be
	 overwritten at runtime whatever what is written on it).
	"
	instruction9 := self newInstruction
		from: (anAssembler reservedMemoryZoneNamed: #ADD_ZERO_FLAG_PAGE);
		to: (anAssembler registerNamed: #ZERO);
		jump: BPNextInstructionReference new;
		beAddedTo: anAssembler.
	instruction1
		to: (instruction7 asReference offset: 1);
		jump: instruction2 asReference.
	instruction2
		to: (instruction8 asReference offset: 1);
		jump: instruction3 asReference.
	instruction3
		to: (instruction9 asReference offset: 1);
		jump: instruction4 asReference.
	instruction4
		to: (instruction7 asReference offset: 2);
		jump: instruction5 asReference.
	instruction5
		to: (instruction8 asReference offset: 2);
		jump: instruction6 asReference.
	instruction6
		to: (instruction9 asReference offset: 2);
		jump: instruction7 asReference.
	instruction7
		jump: instruction8 asReference.
	instruction8
		jump: instruction9 asReference.
]

{ #category : #accessing }
BPAdd >> source [
	^ source
]

{ #category : #accessing }
BPAdd >> source: anObject [
	source := anObject
]

{ #category : #accessing }
BPAdd >> target [
	^ target
]

{ #category : #accessing }
BPAdd >> target: anObject [
	target := anObject
]
