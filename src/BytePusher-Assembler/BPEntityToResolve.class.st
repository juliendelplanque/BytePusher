Class {
	#name : #BPEntityToResolve,
	#superclass : #BPEntity,
	#instVars : [
		'offset'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #initialization }
BPEntityToResolve >> initialize [
	super initialize.
	self offset: 0
]

{ #category : #accessing }
BPEntityToResolve >> offset [
	^ offset
]

{ #category : #accessing }
BPEntityToResolve >> offset: anObject [
	offset := anObject
]
