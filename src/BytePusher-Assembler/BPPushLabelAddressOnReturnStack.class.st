Class {
	#name : #BPPushLabelAddressOnReturnStack,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'label'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPPushLabelAddressOnReturnStack >> generateFor: anAssembler [
	| labelObject |
	labelObject := self label forAssembler: anAssembler.
	anAssembler pushOnReturnStack: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + (labelObject asDataAccess byteIndex: 0).
	anAssembler pushOnReturnStack: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + (labelObject asDataAccess byteIndex: 1).
	anAssembler pushOnReturnStack: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + (labelObject asDataAccess byteIndex: 2)
]

{ #category : #private }
BPPushLabelAddressOnReturnStack >> generateLabel [
	self label: ('pcSerializationLabel' , UUIDGenerator next asString) asSymbol.
	^ self label
]

{ #category : #accessing }
BPPushLabelAddressOnReturnStack >> label [
	^ label
]

{ #category : #accessing }
BPPushLabelAddressOnReturnStack >> label: anObject [
	label := anObject
]
