"
Generates instructions that decrement the value stored at an address.
"
Class {
	#name : #BPDecrement,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'register'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPDecrement >> generateFor: anAssembler [
	BPLookupPage new
		assemblerInstructionForNewInstructions: self;
		addressForInput: self register;
		addressForResult: self register;
		pageName: #DECREMENT_PAGE;
		generateFor: anAssembler
]

{ #category : #accessing }
BPDecrement >> register [
	^ register
]

{ #category : #accessing }
BPDecrement >> register: anObject [
	register := anObject
]
