Class {
	#name : #BPVMStepper,
	#superclass : #Object,
	#instVars : [
		'virtualMachine',
		'state'
	],
	#category : #'BytePusher-VM-Debugging-Stepper'
}

{ #category : #'instance creation' }
BPVMStepper class >> virtualMachine: aBPVirtualMachine [ 
	^ self new
		virtualMachine: aBPVirtualMachine;
		yourself
]

{ #category : #states }
BPVMStepper >> beInInnerLoopState [
	self state: BPVMInnerLoop new
]

{ #category : #states }
BPVMStepper >> beInReadKeyboardState [
	self state: BPVMReadKeyboard new
]

{ #category : #states }
BPVMStepper >> beInReadProgramCounterState [
	self state: BPVMReadProgramCounter new
]

{ #category : #states }
BPVMStepper >> beInSendAudioState [
	self state: BPVMSendAudioDevice new
]

{ #category : #states }
BPVMStepper >> beInSendDisplayState [
	self state: BPVMSendDisplayFrame new
]

{ #category : #vm }
BPVMStepper >> executeInnerLoop [
	self virtualMachine executeInnerLoop
]

{ #category : #initialization }
BPVMStepper >> initialize [
	super initialize.
	self state: BPVMReadKeyboard new
]

{ #category : #vm }
BPVMStepper >> loadProgramCounter [
	self virtualMachine loadProgramCounter
]

{ #category : #accessing }
BPVMStepper >> state [
	^ state
]

{ #category : #accessing }
BPVMStepper >> state: anObject [
	state := anObject
]

{ #category : #stepping }
BPVMStepper >> step [
	self state executeFor: self
]

{ #category : #accessing }
BPVMStepper >> virtualMachine [
	^ virtualMachine
]

{ #category : #accessing }
BPVMStepper >> virtualMachine: anObject [
	virtualMachine := anObject
]
