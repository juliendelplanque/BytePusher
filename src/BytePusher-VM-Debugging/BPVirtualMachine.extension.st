Extension { #name : #BPVirtualMachine }

{ #category : #'*BytePusher-VM-Debugging' }
BPVirtualMachine >> stepper [
	^ BPVMStepper virtualMachine: self
]
