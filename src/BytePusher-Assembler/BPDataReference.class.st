Class {
	#name : #BPDataReference,
	#superclass : #BPReferenceToResolve,
	#instVars : [
		'data'
	],
	#category : #'BytePusher-Assembler'
}

{ #category : #'instance creation' }
BPDataReference class >> data: data [
	^ self new
		data: data;
		yourself
]

{ #category : #visiting }
BPDataReference >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPDataReference: self
]

{ #category : #accessing }
BPDataReference >> data [
	^ data
]

{ #category : #accessing }
BPDataReference >> data: anObject [
	data := anObject
]
