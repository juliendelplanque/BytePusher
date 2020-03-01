Class {
	#name : #BPCall,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'address',
		'label'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPCall >> address [
	^ address
]

{ #category : #accessing }
BPCall >> address: anObject [
	address := anObject
]

{ #category : #generating }
BPCall >> generateFor: anAssembler [
	self generateLabel.
	anAssembler
		pushAddressOfLabel: self label;
		jump: self address;
		label: self label
]

{ #category : #private }
BPCall >> generateLabel [
	self label: ('pcSerializationLabel' , UUIDGenerator next asString) asSymbol.
	^ self label
]

{ #category : #accessing }
BPCall >> label [
	^ label
]

{ #category : #accessing }
BPCall >> label: anObject [
	label := anObject
]
