Class {
	#name : #BPMemoryReference,
	#superclass : #BPReferenceToEntityWithAddress,
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'as yet unclassified' }
BPMemoryReference class >> on: anObjectWithAddress offset: anInteger [
	^ self new
		objectWithAddress: anObjectWithAddress;
		offset: anInteger;
		yourself
]

{ #category : #visiting }
BPMemoryReference >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPOffsetReference: self
]

{ #category : #'assembler-dispatch' }
BPMemoryReference >> forAssembler: aBPAssembler [ 
	^ self
]
