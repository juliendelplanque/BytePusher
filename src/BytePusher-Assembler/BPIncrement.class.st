"
Generates instructions that increment the value stored at an address.
"
Class {
	#name : #BPIncrement,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'register'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPIncrement >> generateFor: anAssembler [
	BPLookupPage new
		assemblerInstructionForNewInstructions: self;
		addressForInput: self register;
		addressForResult: self register;
		pageName: #INCREMENT_PAGE;
		generateFor: anAssembler
]

{ #category : #accessing }
BPIncrement >> register [
	^ register
]

{ #category : #accessing }
BPIncrement >> register: anObject [
	register := anObject
]
