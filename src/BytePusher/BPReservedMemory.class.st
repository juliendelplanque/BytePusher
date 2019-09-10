Class {
	#name : #BPReservedMemory,
	#superclass : #Object,
	#instVars : [
		'name',
		'startAddress',
		'endAddress'
	],
	#category : #'BytePusher-Assembly'
}

{ #category : #'instance creation' }
BPReservedMemory class >> name: aString startAddress: startAddress endAddress: endAddress [
	^ self new
		name: aString;
		startAddress: startAddress asBPAddress;
		endAddress: endAddress asBPAddress;
		yourself
]

{ #category : #'instance creation' }
BPReservedMemory class >> name: aString startAddress: startAddress size: size [
	^ self name: aString startAddress: startAddress endAddress: startAddress + size
]

{ #category : #accessing }
BPReservedMemory >> address [
	"To be polymorphic with BPRegister."
	^ self startAddress
]

{ #category : #accessing }
BPReservedMemory >> endAddress [
	^ endAddress
]

{ #category : #accessing }
BPReservedMemory >> endAddress: anObject [
	endAddress := anObject
]

{ #category : #accessing }
BPReservedMemory >> name [
	^ name
]

{ #category : #accessing }
BPReservedMemory >> name: anObject [
	name := anObject
]

{ #category : #accessing }
BPReservedMemory >> startAddress [
	^ startAddress
]

{ #category : #accessing }
BPReservedMemory >> startAddress: anObject [
	startAddress := anObject
]
