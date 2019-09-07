Class {
	#name : #BPOpcodeBankBuilder,
	#superclass : #Object,
	#category : #'BytePusher-Core'
}

{ #category : #accessing }
BPOpcodeBankBuilder >> endAddress [
	^ self subclassResponsibility
]

{ #category : #accessing }
BPOpcodeBankBuilder >> startAddress [
	^ self subclassResponsibility
]

{ #category : #writing }
BPOpcodeBankBuilder >> writeBankOn: aByteArray [
	^ self subclassResponsibility
]
