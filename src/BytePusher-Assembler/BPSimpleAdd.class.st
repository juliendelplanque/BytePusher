"
Adds two numbers together and store result in source register.
This operations will NOT modify the carry and zero flag. 

ADD reg, reg
ADD reg, address
ADD reg, constant
"
Class {
	#name : #BPSimpleAdd,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'source',
		'target'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPSimpleAdd >> generateFor: anAssembler [
	| sourceForAssembler targetForAssembler instruction1 instruction2 instruction3 |
	sourceForAssembler := self source forAssembler: anAssembler.
	targetForAssembler := self target forAssembler: anAssembler.
	"First, copy data at fromAddress to location of the add instructions."
	instruction1 := self newInstruction
		from: sourceForAssembler;
		beAddedTo: anAssembler.
	"Second, copy data at toAddress to location of the add instructions."
	instruction2 := self newInstruction
		from: targetForAssembler;
		beAddedTo: anAssembler.
	"Third, create the actual add instruction (beware the 16 least
	 significant bit of the #from address
	 will be set by the 2 previous instructions, so they it will be
	 overwritten at runtime whatever what is written on it).
	"
	instruction3 := self newInstruction
		from: (anAssembler reservedMemoryZoneNamed: #ADD_PAGE);
		to: sourceForAssembler;
		beAddedTo: anAssembler.
	instruction1
		to: (instruction3 asReference offset: 1);
		jump: instruction2 asReference.
	instruction2
		to: (instruction3 asReference offset: 2);
		jump: instruction3 asReference.
	instruction3
		jump: BPNextInstructionReference new.
]

{ #category : #accessing }
BPSimpleAdd >> source [
	^ source
]

{ #category : #accessing }
BPSimpleAdd >> source: anObject [
	source := anObject
]

{ #category : #accessing }
BPSimpleAdd >> target [
	^ target
]

{ #category : #accessing }
BPSimpleAdd >> target: anObject [
	target := anObject
]
