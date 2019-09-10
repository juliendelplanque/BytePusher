Class {
	#name : #BPLayoutObject,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'BytePusher-Assembly'
}

{ #category : #accessing }
BPLayoutObject >> addressesInterval [
	^ self startAddress to: self endAddress
]

{ #category : #accessing }
BPLayoutObject >> endAddress [
	^ self subclassResponsibility
]

{ #category : #accessing }
BPLayoutObject >> name [
	^ name
]

{ #category : #accessing }
BPLayoutObject >> name: anObject [
	name := anObject
]

{ #category : #printing }
BPLayoutObject >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self name printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
BPLayoutObject >> startAddress [
	^ self subclassResponsibility
]

{ #category : #accessing }
BPLayoutObject >> typeName [
	^ self subclassResponsibility
]
