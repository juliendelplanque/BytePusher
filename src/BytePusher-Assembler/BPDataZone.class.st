Class {
	#name : #BPDataZone,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'byteArray'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPDataZone >> byteArray [
	^ byteArray
]

{ #category : #accessing }
BPDataZone >> byteArray: anObject [
	byteArray := anObject
]

{ #category : #generating }
BPDataZone >> generateFor: anAssembler [
	self newData
		data: self byteArray;
		beAddedTo: anAssembler
]
