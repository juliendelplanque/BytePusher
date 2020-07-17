Class {
	#name : #BPDataToResolve,
	#superclass : #BPEntityWithAddress,
	#instVars : [
		'data',
		'assemblerInstruction'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #visiting }
BPDataToResolve >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPDataToResolve: self
]

{ #category : #accessing }
BPDataToResolve >> assemblerInstruction [
	^ assemblerInstruction
]

{ #category : #accessing }
BPDataToResolve >> assemblerInstruction: anObject [
	assemblerInstruction := anObject
]

{ #category : #adding }
BPDataToResolve >> beAddedTo: anAssembler [
	anAssembler addInstruction: self
]

{ #category : #accessing }
BPDataToResolve >> data [
	^ data
]

{ #category : #accessing }
BPDataToResolve >> data: anObject [
	data := anObject
]

{ #category : #testing }
BPDataToResolve >> isInstructionToResolve [
	^ false
]

{ #category : #accessing }
BPDataToResolve >> spaceInMemoryRequired [
	self data class = ByteArray
		ifTrue: [ ^ self data size ].
		
	^ ADDRESS_SIZE
]
