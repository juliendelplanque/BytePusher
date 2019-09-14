Class {
	#name : #BPAddressDataReference,
	#superclass : #BPReferenceToResolve,
	#instVars : [
		'address',
		'byteIndex'
	],
	#category : #'BytePusher-Assembler'
}

{ #category : #'instance creation' }
BPAddressDataReference class >> address: address byteIndex: byteIndex [
	^ self new
		address: address;
		byteIndex: byteIndex;
		yourself
]

{ #category : #accessing }
BPAddressDataReference >> address [
	^ address
]

{ #category : #accessing }
BPAddressDataReference >> address: anObject [
	address := anObject
]

{ #category : #accessing }
BPAddressDataReference >> byteIndex [
	^ byteIndex
]

{ #category : #accessing }
BPAddressDataReference >> byteIndex: anObject [
	byteIndex := anObject
]
