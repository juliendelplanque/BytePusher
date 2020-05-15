Class {
	#name : #BPEntityToResolve,
	#superclass : #Object,
	#instVars : [
		'offset'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #accessing }
BPEntityToResolve >> offset [
	^ offset
]

{ #category : #accessing }
BPEntityToResolve >> offset: anObject [
	offset := anObject
]
