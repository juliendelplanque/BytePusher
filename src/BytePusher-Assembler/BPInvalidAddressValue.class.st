Class {
	#name : #BPInvalidAddressValue,
	#superclass : #BPError,
	#instVars : [
		'value'
	],
	#category : #'BytePusher-Assembler-Errors'
}

{ #category : #'instance creation' }
BPInvalidAddressValue class >> signalForValue: value [
	^ self new
		value: value;
		signal
]

{ #category : #accessing }
BPInvalidAddressValue >> value [
	^ value
]

{ #category : #accessing }
BPInvalidAddressValue >> value: anObject [
	value := anObject
]
