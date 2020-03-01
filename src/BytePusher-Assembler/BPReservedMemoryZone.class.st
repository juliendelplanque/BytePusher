"
I model a zone of the memory that has been reserved for a specific purpose.

Example of such zones are:
- Sound sample
- Pixels data
- Opcode bank
- etc...
"
Class {
	#name : #BPReservedMemoryZone,
	#superclass : #BPLayoutObject,
	#instVars : [
		'startAddress',
		'endAddress'
	],
	#category : #'BytePusher-Assembler-Memory'
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

{ #category : #arithmetic }
BPReservedMemoryZone >> + anInteger [
	^ BPOffsetReference on: self offset: anInteger
]

{ #category : #arithmetic }
BPReservedMemoryZone >> - anInteger [
	^ BPOffsetReference on: self offset: anInteger negated
]

{ #category : #visiting }
BPReservedMemoryZone >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPReservedMemoryZone: self
]

{ #category : #reading }
BPReservedMemoryZone >> access: aCollection [ 
	^ ByteArray streamContents: [ :stream |
		self address memoryAddress + 1 to: self endAddress memoryAddress + 1 do: [ :index |
			stream nextPut: (aCollection at: index) ] ]
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
BPReservedMemoryZone >> isForOpcodeBank [
	^ false
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
