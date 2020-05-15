Class {
	#name : #BPAbstractInstructionReference,
	#superclass : #BPEntityToResolve,
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'instance creation' }
BPAbstractInstructionReference >> fromAddressHighByte [
	self offset: 0
]

{ #category : #'instance creation' }
BPAbstractInstructionReference >> fromAddressLowByte [
	self offset: 2
]

{ #category : #'instance creation' }
BPAbstractInstructionReference >> fromAddressMiddleByte [
	self offset: 1
]

{ #category : #'instance creation' }
BPAbstractInstructionReference >> jumpAddressHighByte [
	self offset: 6
]

{ #category : #'instance creation' }
BPAbstractInstructionReference >> jumpAddressLowByte [
	self offset: 8
]

{ #category : #'instance creation' }
BPAbstractInstructionReference >> jumpAddressMiddleByte [
	self offset: 7
]

{ #category : #'instance creation' }
BPAbstractInstructionReference >> toAddressHighByte [
	self offset: 3
]

{ #category : #'instance creation' }
BPAbstractInstructionReference >> toAddressLowByte [
	self offset: 5
]

{ #category : #'instance creation' }
BPAbstractInstructionReference >> toAddressMiddleByte [
	self offset: 4
]
