Class {
	#name : #BPLookupBank,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'addressForInput1',
		'addressForInput2',
		'addressForResult',
		'bankName'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPLookupBank >> addressForInput1 [
	^ addressForInput1
]

{ #category : #accessing }
BPLookupBank >> addressForInput1: anObject [
	addressForInput1 := anObject
]

{ #category : #accessing }
BPLookupBank >> addressForInput2 [
	^ addressForInput2
]

{ #category : #accessing }
BPLookupBank >> addressForInput2: anObject [
	addressForInput2 := anObject
]

{ #category : #accessing }
BPLookupBank >> addressForResult [
	^ addressForResult
]

{ #category : #accessing }
BPLookupBank >> addressForResult: anObject [
	addressForResult := anObject
]

{ #category : #accessing }
BPLookupBank >> bankName [
	^ bankName
]

{ #category : #accessing }
BPLookupBank >> bankName: anObject [
	bankName := anObject
]

{ #category : #generating }
BPLookupBank >> generateFor: anAssembler [
	| sourceForAssembler targetForAssembler instruction1 instruction2 instruction3 |
	sourceForAssembler := self addressForInput1 forAssembler: anAssembler.
	targetForAssembler := self addressForInput2 forAssembler: anAssembler.
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
		from: (anAssembler reservedMemoryZoneNamed: self bankName);
		to: (self addressForResult forAssembler: anAssembler);
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
