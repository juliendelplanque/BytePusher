"
I am a reserved memory zone that simulate a register.
Such register hold one byte of data.

When a register is defined for a memory layout, the developer can refer to it via its name.
"
Class {
	#name : #BPRegister,
	#superclass : #BPLayoutObject,
	#instVars : [
		'address'
	],
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #'instance creation' }
BPRegister class >> name: name address: address [
	^ self new
		name: name;
		address: address;
		yourself
]

{ #category : #visiting }
BPRegister >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPRegister: self
]

{ #category : #accessing }
BPRegister >> address [
	^ address
]

{ #category : #accessing }
BPRegister >> address: anObject [
	address := anObject asBPAddress
]

{ #category : #converting }
BPRegister >> asBPAddress [
	^ self address
]

{ #category : #accessing }
BPRegister >> endAddress [
	"Registers old 1 Byte of data."
	^ self address
]

{ #category : #testing }
BPRegister >> isRegister [
	^ true
]

{ #category : #accessing }
BPRegister >> startAddress [
	^ self address
]

{ #category : #accessing }
BPRegister >> typeName [
	^ 'Register'
]

{ #category : #accessing }
BPRegister >> valueIn: memory [
	"Returns the value of the register in a given #memory.
	 That is to say the byte stored in the register.
	"
	^ self address access: memory
]
