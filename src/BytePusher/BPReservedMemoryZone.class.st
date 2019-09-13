Class {
	#name : #BPReservedMemoryZone,
	#superclass : #BPLayoutObject,
	#instVars : [
		'startAddress',
		'endAddress'
	],
	#category : #'BytePusher-Assembly'
}

{ #category : #'instance creation' }
BPReservedMemoryZone class >> name: aString startAddress: startAddress endAddress: endAddress [
	^ self new
		name: aString;
		startAddress: startAddress asBPAddress;
		endAddress: endAddress asBPAddress;
		yourself
]

{ #category : #'instance creation' }
BPReservedMemoryZone class >> name: aString startAddress: startAddress size: size [
	^ self name: aString startAddress: startAddress endAddress: startAddress + size - 1
]

{ #category : #visiting }
BPReservedMemoryZone >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPReservedMemoryZone: self
]

{ #category : #accessing }
BPReservedMemoryZone >> address [
	"To be polymorphic with BPRegister."
	^ self startAddress
]

{ #category : #converting }
BPReservedMemoryZone >> asBPAddress [
	^ self address
]

{ #category : #accessing }
BPReservedMemoryZone >> endAddress [
	^ endAddress
]

{ #category : #accessing }
BPReservedMemoryZone >> endAddress: anObject [
	endAddress := anObject
]

{ #category : #testing }
BPReservedMemoryZone >> isReservedMemoryZone [
	^ true
]

{ #category : #accessing }
BPReservedMemoryZone >> startAddress [
	^ startAddress
]

{ #category : #accessing }
BPReservedMemoryZone >> startAddress: anObject [
	startAddress := anObject
]

{ #category : #accessing }
BPReservedMemoryZone >> typeName [
	^ 'Reserved Memory Zone'
]
