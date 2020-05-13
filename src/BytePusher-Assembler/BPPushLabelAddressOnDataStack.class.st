Class {
	#name : #BPPushLabelAddressOnDataStack,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'label'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPPushLabelAddressOnDataStack >> generateFor: anAssembler [
	| labelObject |
	labelObject := self label forAssembler: anAssembler.
	anAssembler pushOnDataStack: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + (labelObject asAddressReference byteIndex: 0).
	anAssembler pushOnDataStack: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + (labelObject asAddressReference byteIndex: 1).
	anAssembler pushOnDataStack: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + (labelObject asAddressReference byteIndex: 2)
]

{ #category : #private }
BPPushLabelAddressOnDataStack >> generateLabel [
	self label: ('pcSerializationLabel' , UUIDGenerator next asString) asSymbol.
	^ self label
]

{ #category : #accessing }
BPPushLabelAddressOnDataStack >> label [
	^ label
]

{ #category : #accessing }
BPPushLabelAddressOnDataStack >> label: anObject [
	label := anObject
]
