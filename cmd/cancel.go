// Copyright © 2016 Calvin Leung Huang <https://github.com/calvn>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

func newCancelCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "cancel",
		Short: "Cancel a pending order",
		Long:  `Cancel a pending order`,
		Run:   cancelCmdFunc,
	}

	return cmd
}

func cancelCmdFunc(cmd *cobra.Command, args []string) {
	if len(args) == 0 {
		return
	}

	output, err := brokrRunner.CancelOrder(args)
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(output)
}
