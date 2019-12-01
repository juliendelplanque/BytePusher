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
	instruction1 := BPInstructionToResolve new
		from: sourceForAssembler;
		beAddedTo: anAssembler.
	"Second, copy data at toAddress to location of the add instructions."
	instruction2 := BPInstructionToResolve new
		from: targetForAssembler;
		beAddedTo: anAssembler.
	"Third, create the actual add instruction (beware the 16 least
	 significant bit of the #from address
	 will be set by the 2 previous instructions, so they it will be
	 overwritten at runtime whatever what is written on it).
	"
	instruction3 := BPInstructionToResolve new
		from: (anAssembler reservedMemoryZoneNamed: #ADD_PAGE);
		to: sourceForAssembler;
		beAddedTo: anAssembler.
	instruction1
		to: (instruction3 asReference byteIndex: 1);
		jump: instruction2 asReference;
		tag: #simpleAdd:to:.
	instruction2
		to: (instruction3 asReference byteIndex: 2);
		jump: instruction3 asReference;
		tag: #simpleAdd:to:.
	instruction3
		jump: BPNextInstructionReference new;
		tag: #simpleAdd:to:.
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
