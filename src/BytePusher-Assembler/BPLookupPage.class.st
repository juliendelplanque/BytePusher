Class {
	#name : #BPLookupPage,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'addressForInput',
		'addressForResult',
		'pageName'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPLookupPage >> addressForInput [
	^ addressForInput
]

{ #category : #accessing }
BPLookupPage >> addressForInput: anObject [
	addressForInput := anObject
]

{ #category : #accessing }
BPLookupPage >> addressForResult [
	^ addressForResult
]

{ #category : #accessing }
BPLookupPage >> addressForResult: anObject [
	addressForResult := anObject
]

{ #category : #generating }
BPLookupPage >> generateFor: anAssembler [
	| instruction1 instruction2 |
	instruction1 := self newInstruction.
	instruction2 := self newInstruction.
	instruction1
		from: (self addressForInput forAssembler: anAssembler);
		to: (instruction2 asReference byteIndex: 2);
		jump: instruction2 asReference;
		beAddedTo: anAssembler.
	instruction2
		from: (anAssembler reservedMemoryZoneNamed: self pageName);
		to: (self addressForResult forAssembler: anAssembler);
		jump: BPNextInstructionReference new;
		beAddedTo: anAssembler
]

{ #category : #accessing }
BPLookupPage >> pageName [
	^ pageName
]

{ #category : #accessing }
BPLookupPage >> pageName: anObject [
	pageName := anObject
]
