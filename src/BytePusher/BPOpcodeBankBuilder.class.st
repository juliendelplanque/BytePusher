Class {
	#name : #BPOpcodeBankBuilder,
	#superclass : #Object,
	#category : #'BytePusher-Assembly'
}

{ #category : #accessing }
BPOpcodeBankBuilder class >> endAddress [
	^ self subclassResponsibility
]

{ #category : #accessing }
BPOpcodeBankBuilder class >> startAddress [
	^ self subclassResponsibility
]

{ #category : #writing }
BPOpcodeBankBuilder class >> writeBankOn: aByteArray [
	^ self new writeBankOn: aByteArray
]

{ #category : #accessing }
BPOpcodeBankBuilder >> endAddress [
	^ self class endAddress
]

{ #category : #accessing }
BPOpcodeBankBuilder >> startAddress [
	^ self class startAddress
]

{ #category : #writing }
BPOpcodeBankBuilder >> writeBankOn: aByteArray [
	^ self subclassResponsibility
]
