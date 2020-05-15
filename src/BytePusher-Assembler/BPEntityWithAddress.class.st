Class {
	#name : #BPEntityWithAddress,
	#superclass : #BPEntity,
	#instVars : [
		'address'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #accessing }
BPEntityWithAddress >> address [
	^ address
]

{ #category : #accessing }
BPEntityWithAddress >> address: anObject [
	address := anObject
]
